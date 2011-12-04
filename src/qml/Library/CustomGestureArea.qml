import Qt 4.7

MouseArea {
    anchors.fill: parent
    signal swipeRight;
    signal swipeLeft;
    signal swipeUp;
    signal swipeDown;

    property int startX;
    property int startY;

    onPressed: {
        startX = mouse.x;
        startY = mouse.y;
        console.log("Gesture started");
    }

    onReleased: {
        var deltax = mouse.x - startX;
        var deltay = mouse.y - startY;

        if (Math.abs(deltax) > 30 || Math.abs(deltay) > 30) {
            if (deltax > 20 && Math.abs(deltay) < 20) {
                // swipe right
                swipeRight();
            } else if (deltax < -20 && Math.abs(deltay) < 20) {
                // swipe left
                swipeLeft();
            } else if (Math.abs(deltax) < 20 && deltay > 20) {
                // swipe down
                swipeDown();
            } else if (Math.abs(deltax) < 20 && deltay < 20) {
                // swipe up
                swipeUp();
            }
            console.log("Gesture ended");
        }
        else{
            console.log("Gesture ended with deltax = "+deltax);
        }
    }
}
