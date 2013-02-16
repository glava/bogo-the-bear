/**
 * Created with IntelliJ IDEA.
 * User: goran
 * Date: 2/16/13
 * Time: 2:52 PM
 * To change this template use File | Settings | File Templates.
 */
package com.org.bogo.kinect.skeleton.gesture {
public class Hand {
    public static const RIGHT_HAND:String = "Right.Hand";
    public var side:String = RIGHT_HAND;

    public function Hand(side:String) {
        this.side = side;
    }

    public static function getRightHand():Hand {
        return new Hand(RIGHT_HAND);
    }
}
}
