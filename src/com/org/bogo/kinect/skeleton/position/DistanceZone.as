/**
 * Created with IntelliJ IDEA.
 * User: goran
 * Date: 2/15/13
 * Time: 5:27 PM
 * To change this template use File | Settings | File Templates.
 */
package com.org.bogo.kinect.skeleton.position {
public class DistanceZone {

    public static const GREEN_ZONE:String = "Green.Level";
    public static const BLUE_ZONE:String = "Blue.Level";
    public static const RED_ZONE:String = "Red.Level";

    public static const RED_ZONE_LIMIT:int = 1300;
    public static const BLUE_ZONE_LIMIT:int = 2500;

    private var _currentZone:String = BLUE_ZONE;

    public function DistanceZone() {
    }

    public function get currentZone():String {
        return _currentZone;
    }

    public function set currentZone(value:String):void {
        _currentZone = value;
    }

    public function isGreenZone():Boolean {
        return currentZone == GREEN_ZONE;
    }

    public function isRedZone():Boolean {
        return currentZone == RED_ZONE;
    }

    public function isBlueZone():Boolean {
        return currentZone == BLUE_ZONE;
    }
}

}
