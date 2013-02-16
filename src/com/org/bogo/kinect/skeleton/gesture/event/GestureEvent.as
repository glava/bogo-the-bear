/**
 * Created with IntelliJ IDEA.
 * User: goran
 * Date: 2/16/13
 * Time: 2:49 PM
 * To change this template use File | Settings | File Templates.
 */
package com.org.bogo.kinect.skeleton.gesture.event {
import com.org.bogo.kinect.skeleton.gesture.Hand;

import flash.events.Event;

import mx.states.SetEventHandler;

public class GestureEvent extends Event{

    public static const WAVE_STARTED:String = "Wave.Started";
    public static const WAVE_ENDED:String = "Wave.Ended";

    public var hand:Hand;

    public function GestureEvent(type:String = WAVE_STARTED, hand:Hand = null, bubbles:Boolean=true, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
        this.hand = hand;
    }
}
}
