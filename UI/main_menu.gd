extends Control
const PORT:int = 3000
'''
	@onready是一种注解（语法糖）等价于先在顶部申明
	等价于现在顶部申明var host_button: Button
	再在_ready中赋值host_button = $HBoxContainer/HostButton
	trick1: 可以按住Command+拖动鼠标来快速创建结点的@onready变量申明
	trick2: 你甚至可以多选！
'''
var main_scene: PackedScene = preload('uid://yhurm2fucow5')
# main.tscs和uuid唯一映射，可以防止修改了main.tscn导致的引用失效问题
# 鼠标悬浮在路径上会显示对应的场景
@onready var host_button: Button = $HBoxContainer/HostButton
@onready var join_button: Button = $HBoxContainer/JoinButton

func _ready() -> void:
	# 将Host按钮连接到事件：按下按钮广播信号->_on_host_pressed收听到信号执行自己
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)
	# 没有一个玩家连接该信号就会发送玩家的ID作为参数
	multiplayer.peer_connected.connect(_on_peer_connected)

# Host按钮事件
func _on_host_pressed() -> void: 
	# 创建服务器对等端实例
	var server_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new() # 通过该实例封装的方法来主持服务器
	server_peer.create_server(PORT)
	multiplayer.multiplayer_peer = server_peer
	get_tree().change_scene_to_packed(main_scene) # 通过get_tree()获取到包含当前场景的场景树将本场景树切换到main_scene所对应的场景树
	
# _下划线表示 private/私有方法，不应该从外部调用它
func _on_join_pressed() -> void:
	var client_peer := ENetMultiplayerPeer.new()
	client_peer.create_client("127.0.0.1", PORT)
	multiplayer.multiplayer_peer = client_peer
	get_tree().change_scene_to_packed(main_scene)
	
# 需要再Debug中启用多个实例来进行调试 Debug -> Coustomize Run Instances
func  _on_peer_connected(id: int) -> void: # id是peer连接信号发出的参数
	print("peer connected! %s" % id) # id = 1始终是为服务器预留的，客户端的id是一个随机的整数
	
