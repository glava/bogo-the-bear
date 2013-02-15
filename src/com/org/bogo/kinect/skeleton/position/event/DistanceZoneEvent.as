/**
 * Created with IntelliJ IDEA.
 * User: goran
 * Date: 2/15/13
 * Time: 5:42 PM
 * To change this template use File | Settings | File Templates.
 */
package com.org.bogo.kinect.skeleton.position.event {
import flash.events.Event;

public class DistanceZoneEvent extends Event{

    public static const DISTANCE_ZONE_CHANGED:String = "Green.Level";
    public var distanceZone:String;

    public function DistanceZoneEvent(type:String = DISTANCE_ZONE_CHANGED, distance:String="", bubbles:Boolean=true, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
        this.distanceZone = distance;
    }
}
}
