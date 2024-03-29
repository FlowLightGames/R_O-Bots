extends Node

var path:String=r"C:\Users\Flo\Desktop\Robots_Source"
@export var size:int=6
func _ready()->void:
	var img:Image=Image.create(1,size,false,Image.Format.FORMAT_RGBA8)
	var interval:float=255.0/float(size)
	
	var base:float=interval*0.5
	img.set_pixel(0,0,Color8(int(base),int(base),int(base),255))
	for i:int in range(1,size):
		img.set_pixel(0,i,Color8(int(base+interval*float(i)),int(base+interval*float(i)),int(base+interval*float(i)),255))
		img.save_png(path+"/gray_palette.png")
