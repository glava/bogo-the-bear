/**
 * Created with IntelliJ IDEA.
 * User: goran
 * Date: 2/15/13
 * Time: 5:13 PM
 * To change this template use File | Settings | File Templates.
 */
package com.org.bogo.kinect.skeleton {
import com.as3nui.nativeExtensions.air.kinect.Kinect;
import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
import com.as3nui.nativeExtensions.air.kinect.data.User;
import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
import com.as3nui.nativeExtensions.air.kinect.examples.DemoBase;
import com.org.bogo.kinect.skeleton.position.DistanceZone;
import com.org.bogo.kinect.skeleton.position.event.DistanceZoneEvent;
import com.org.bogo.kinect.skeleton.position.event.DistanceZoneEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

public class SkeletonJointsDemo extends DemoBase {
    public static const KinectMaxDepthInFlash:uint = 200;

    private var device:Kinect;
    private var skeletonRenderers:Vector.<SkeletonRenderer>;
    private var skeletonContainer:Sprite;
    private var currentUser:User;

    private var distanceZone:DistanceZone = new DistanceZone();

    override protected function startDemoImplementation():void {
        if (Kinect.isSupported()) {
            device = Kinect.getDevice();

            var settings:KinectSettings = new KinectSettings();
            settings.skeletonEnabled = true;
            settings.skeletonMirrored = true;

            device.addEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, skeletonsAddedHandler, false, 0, true);
            device.addEventListener(UserEvent.USERS_WITH_SKELETON_REMOVED, skeletonsRemovedHandler, false, 0, true);

            skeletonRenderers = new Vector.<SkeletonRenderer>();
            skeletonContainer = new Sprite();
            addChild(skeletonContainer);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
            device.start(settings);
        }
    }

    protected function skeletonsRemovedHandler(event:UserEvent):void {
        for each(var removedUser:User in event.users) {
            var index:int = -1;
            for (var i:int = 0; i < skeletonRenderers.length; i++) {
                if (skeletonRenderers[i].user == removedUser) {
                    index = i;
                    break;
                }
            }
            if (index > -1) {
                skeletonContainer.removeChild(skeletonRenderers[index]);
                skeletonRenderers.splice(index, 1);
            }
        }

        trace("user removed");
        currentUser = null;
    }

    protected function skeletonsAddedHandler(event:UserEvent):void {
        for each(var addedUser:User in event.users) {
            // if(currentUser != null ) break;
            currentUser = addedUser;
            trace("new user added");
            var skeletonRenderer:SkeletonRenderer = new SkeletonRenderer(addedUser);
            skeletonContainer.addChild(skeletonRenderer);
            skeletonRenderers.push(skeletonRenderer);
        }
    }

    protected function enterFrameHandler(event:Event):void {
        for each(var skeletonRenderer:SkeletonRenderer in skeletonRenderers) {
            skeletonRenderer.explicitWidth = explicitWidth;
            skeletonRenderer.explicitHeight = explicitHeight;
            skeletonRenderer.render();
        }
        if (currentUser != null) {
            checkUserDistance(currentUser);
        }
    }

    private function checkUserDistance(user:User) {
        var distance:Number = user.head.position.world.z;
        var oldDistanceZone:String = distanceZone.currentZone;
        //logic for blue zone
        if (distanceZone.isBlueZone()) {
             if (distance < DistanceZone.RED_ZONE_LIMIT) {
                distanceZone.currentZone = DistanceZone.RED_ZONE;

            } else if (distance > DistanceZone.BLUE_ZONE_LIMIT) {
                distanceZone.currentZone = DistanceZone.GREEN_ZONE;
            }
            //logic for red zone
        } else if (distanceZone.isRedZone()) {
            if (distance > DistanceZone.BLUE_ZONE_LIMIT) {
                distanceZone.currentZone = DistanceZone.GREEN_ZONE;

            } else if (distance > DistanceZone.RED_ZONE_LIMIT) {
                distanceZone.currentZone = DistanceZone.BLUE_ZONE;

            }
            //logic for green zone
        } else if (distanceZone.isGreenZone()) {
            if (distance < DistanceZone.RED_ZONE_LIMIT) {
                distanceZone.currentZone = DistanceZone.RED_ZONE;

            } else if (distance < DistanceZone.BLUE_ZONE_LIMIT) {
                distanceZone.currentZone = DistanceZone.BLUE_ZONE;

            }
        }
        if (oldDistanceZone != distanceZone.currentZone) {
            //there was a change in zone, notify
            dispatchEvent(new DistanceZoneEvent(DistanceZoneEvent.DISTANCE_ZONE_CHANGED, distanceZone.currentZone));
        }
    }

    override protected function stopDemoImplementation():void {
        if (device != null) {
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            device.removeEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, skeletonsAddedHandler);
            device.removeEventListener(UserEvent.USERS_WITH_SKELETON_REMOVED, skeletonsRemovedHandler);
            device.stop();
        }
    }

    override protected function layout():void {
        if (skeletonContainer != null) {

        }
        if (root != null) {
            root.transform.perspectiveProjection.projectionCenter = new Point(explicitWidth * .5, explicitHeight * .5);
        }
    }
}
}

import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
import com.as3nui.nativeExtensions.air.kinect.data.User;
import com.bit101.components.Label;

import flash.display.Sprite;

internal class SkeletonRenderer extends Sprite {

    public var user:User;
    private var labels:Vector.<Label>;
    private var circles:Vector.<Sprite>;

    public var explicitWidth:uint;
    public var explicitHeight:uint;

    public function SkeletonRenderer(user:User) {
        this.user = user;
        labels = new Vector.<Label>();
        circles = new Vector.<Sprite>();
    }

    private function createLabelsIfNeeded():void {
        while (labels.length < user.skeletonJoints.length) {
            labels.push(new Label(this));
        }
    }

    private function createCirclesIfNeeded():void {
        while (circles.length < user.skeletonJoints.length) {
            var circle:Sprite = new Sprite();
            circle.graphics.beginFill(0xff0000);
            circle.graphics.drawCircle(0, 0, 10);
            circle.graphics.endFill();
            addChild(circle);
            circles.push(circle);
        }
    }

    var maxdistance:Number = 0;

    public function render():void {
        graphics.clear();
        var numJoints:uint = user.skeletonJoints.length;
        //create labels
        createLabelsIfNeeded();
        createCirclesIfNeeded();
        for (var i:int = 0; i < numJoints; i++) {

            var joint:SkeletonJoint = user.skeletonJoints[i];
            var label:Label = labels[i];
            var circle:Sprite = circles[i];
            //circle
            circle.x = joint.position.depthRelative.x * explicitWidth;
            circle.y = joint.position.depthRelative.y * explicitHeight;
            //label
            label.text = joint.name;
            label.x = circle.x;
            label.y = circle.y;


        }
    }
}