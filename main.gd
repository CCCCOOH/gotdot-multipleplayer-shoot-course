extends Node

func _ready() -> void:
	#peer_ready.rpc()	# 脚本中的任何函数都是可调用的对象，并对func执行rpc调用，即以rpc方式调用了这个函数
	# 对所有已经连接的对手端进行远程调用（网络请求）
	# 如果四个人都已经连接上了，接下来所有人都会对对手端执行peer_ready操作
	peer_ready.rpc_id(1)	# 只发送给服务器节点而不是发所给所有结点，或者说只在服务器上执行这个函数，而不是每个结点都执行一遍这个函数
# 如果注解中用all_remote会导致yourself is not allowd by selected mode错误
# 原因在于服务器也会执行这个函数，而这个函数用了call_remote后就只能由自身去调用
# 别点结点调用后通知了服务器没有问题，但服务器自己调用就会报错了，所以我们用call_local表示既可以网络调用也可以本地调用（自己调用）
@rpc("any_peer", "call_local", "reliable")	# 表示这是一个远程调用
'''
	rpc补充：
	Remote Procedure Call 远程程序调用
	意思是在一个结点上调用函数会在所有连接的结点上执行
	参数解释: any_peer 允许任何对等端执行 call_local 允许网络和本地执行
'''
func peer_ready() -> void:
	print("peer ready %s " % multiplayer.get_remote_sender_id()) # 打印是哪个结点发出了RPC请求
