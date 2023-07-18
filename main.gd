extends CanvasLayer

var ship_speed : float = 1
var ship_course : float = 1
var wind_speed : float = 1
var wind_direction : float = 1
var value_list : Array 
var ship_speed_info : String = "Ship speed: {} knots"
var ship_course_info : String = "Ship course: {} deg"
var wind_speed_info : String = "Wind speed: {} m/s"
var wind_direction_info : String = "Wind direction: {} deg"

onready var ShipSpeed = $MarginContainer/VBoxContainer/ShipSpeed/Label
onready var ShipCourse = $MarginContainer/VBoxContainer/ShipCourse/Label
onready var WindSpeed = $MarginContainer/VBoxContainer/WindSpeed/Label 
onready var WindDirection = $MarginContainer/VBoxContainer/WindDirection/Label

onready var HSliderShipSpeed = $MarginContainer/VBoxContainer/ShipSpeed/HSliderShipSpeed
onready var HSliderShipCourse = $MarginContainer/VBoxContainer/ShipCourse/HSliderShipCourse
onready var HSliderWindSpeed = $MarginContainer/VBoxContainer/WindSpeed/HSliderWindSpeed
onready var HSliderWindDirection = $MarginContainer/VBoxContainer/WindDirection/HSliderWindDirection


func _ready() -> void:
    ship_speed = HSliderShipSpeed.value
    ship_course = HSliderShipCourse.value
    wind_speed = HSliderWindSpeed.value
    wind_direction = HSliderWindDirection.value
    
    ShipSpeed.set_text(
        ship_speed_info.format([ship_speed], "{}")
    )
    ShipCourse.set_text(
        ship_course_info.format([ship_course], "{}")
    )
    WindSpeed.set_text(
        wind_speed_info.format([wind_speed], "{}")
    )
    WindDirection.set_text(
        wind_direction_info.format([wind_direction], "{}")
    )
    update()
    

func getSpeedMPS(mod:int,speed:float)->float:
    if mod == 1:
        return (speed * 3600) / 1852
    elif mod == 2:
        return (speed * 1000) / 3600
    return speed

func calculation(speed_s:float, course_s:float, speed_w:float, direction_w:float) -> Array:

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

    if (trueWindDerec < 0):
        trueWindDerec = trueWindDerec + 360

    if trueWindDerec > 360:
        trueWindDerec = trueWindDerec - 360

    var trueWindSpeed = windTrueSpeed * 1852 / 3600

    return [int(trueWindDerec), int(trueWindSpeed)]


func update() -> void:
    value_list = calculation(ship_speed, ship_course, wind_speed, wind_direction)
    $MarginContainer/VBoxContainer/TrueWind.set_text(
        "Wind Direction: {}, speed: {}".format(value_list, "{}")
    )


func _on_HSliderWindSpeed_value_changed(value) -> void:
    wind_speed = value
    WindSpeed.set_text(
        wind_speed_info.format([value], "{}")
    )
    update()


func _on_HSliderWindDirection_value_changed(value) -> void:
    wind_direction = value
    WindDirection.set_text(
        wind_direction_info.format([value], "{}")
    )
    update()


func _on_HSliderShipSpeed_value_changed(value) -> void:
    ship_speed = value
    ShipSpeed.set_text(
        ship_speed_info.format([value], "{}")
    )
    update()


func _on_HSliderShipCourse_value_changed(value) -> void:
    ship_course = value
    ShipCourse.set_text(
        ship_course_info.format([value], "{}")
    )
    update()


func _on_Button_pressed() -> void:
    $MarginContainer/PopupDialog.popup()


func _on_ButtonSafe_pressed() -> void:
    ship_speed = float($"MarginContainer/PopupDialog/VBoxContainer/VBoxContainer/LineEdit".text)
    $"MarginContainer/VBoxContainer/ShipSpeed/HSliderShipSpeed".set_max(ship_speed)
    wind_speed = float($"MarginContainer/PopupDialog/VBoxContainer/VBoxContainer2/LineEdit".text)
    $"MarginContainer/VBoxContainer/WindSpeed/HSliderWindSpeed".set_max(wind_speed)
    $MarginContainer/PopupDialog.visible = false


func _on_Button2_pressed() -> void:
    get_tree().quit()
