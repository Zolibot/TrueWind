extends CanvasLayer

var ship_speed : float = 1
var ship_course : float = 1
var wind_speed : float = 1
var wind_direction : float = 1
var wind_speed_correction : float = 1
var value_list : Array 
	

func getSpeedMPS(mod:int,speed:float)->float:
	if mod == 1:
		return (speed * 3600) / 1852
	elif mod == 2:
		return (speed * 1000) / 3600
	return speed

func calculation(speed_s:float, course_s:float, speed_w:float, direction_w:float):

	var windSpeedSeemMPH = getSpeedMPS(1, speed_w)
	var windDerecABS = abs(direction_w)
	var windTrueSpeed = sqrt(pow(windSpeedSeemMPH, 2) + pow(speed_s, 2) - 2 * windSpeedSeemMPH * speed_s * cos(deg2rad(direction_w)))
	var derect = rad2deg(asin(sin(deg2rad(windDerecABS)) * speed_s / windTrueSpeed))
	var windDerect = derect + windDerecABS
	var trueWindDerec:float

	if direction_w > 0:
		trueWindDerec = course_s + windDerect
	else:
		trueWindDerec = course_s - windDerect

	if (trueWindDerec > 0):
		pass
	else:
		trueWindDerec = trueWindDerec + 360

	if trueWindDerec > 360:
		trueWindDerec = trueWindDerec - 360

	var trueWindSpeed = windTrueSpeed * 1852 / 3600

	return [int(trueWindDerec), int(trueWindSpeed)]


func go():
	value_list = calculation(ship_speed, ship_course, wind_speed, wind_direction)
	$MarginContainer/VBoxContainer/TrueWind.set_text(
		"Wind Direction: {}, speed: {}".format(value_list, "{}")
	)


func _on_HSliderWindSpeed_value_changed(value):
	wind_speed = value
	$MarginContainer/VBoxContainer/WindSpeed/Label.set_text(
		"Wind speed: {}".format([value], "{}")
	)
	go()


func _on_HSliderWindDirection_value_changed(value):
	wind_direction = value
	$MarginContainer/VBoxContainer/WindDirection/Label.set_text(
		"Wind direction: {}".format([value], "{}")
	)
	go()

func true_wind():
	$MarginContainer/VBoxContainer/TrueWind.set_text(str(wind_speed_correction))


func _on_HSliderShipSpeed_value_changed(value):
	ship_speed = value
	$"MarginContainer/VBoxContainer/ShipSpeed/Label".set_text(
		"Ship speed: {}".format([value], "{}")
	)
	go()


func _on_HSliderShipCourse_value_changed(value):
	ship_course = value
	$MarginContainer/VBoxContainer/ShipCourse/Label.set_text(
		"Ship course: {}".format([value], "{}")
	)
	go()


func _on_Button_pressed():
	$MarginContainer/PopupDialog.popup()


func _on_ButtonSafe_pressed():
	ship_speed = float($"MarginContainer/PopupDialog/VBoxContainer/VBoxContainer/LineEdit".text)
	$"MarginContainer/VBoxContainer/ShipSpeed/HSliderShipSpeed".set_max(ship_speed)
	wind_speed = float($"MarginContainer/PopupDialog/VBoxContainer/VBoxContainer2/LineEdit".text)
	$"MarginContainer/VBoxContainer/WindSpeed/HSliderWindSpeed".set_max(wind_speed)
	$MarginContainer/PopupDialog.visible = false


func _on_Button2_pressed():
	get_tree().quit()
