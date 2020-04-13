// helper functions for the GUI

// message will display a hud text message
function message {
    parameter msg.
    parameter color is white.
    parameter delay is 5. // delay 5 seconds
    parameter style is 2. //upper center
    parameter size is 20.
    parameter echo is false.
    hudtext(msg, delay, style, size, color, echo).
    if color = white {
        print "Info: " + msg.
    }
    if color = yellow {
        print "Warning: " + msg.
    }
    if color = red {
        print "Error: " + msg.
    }
}

message("HUD initialized...").