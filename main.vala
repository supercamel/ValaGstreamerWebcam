

using Gtk;
using Gst;


public bool find_video_sink(out Gst.Element sink)
{
    Gst.StateChangeReturn sret;
    sink = Gst.ElementFactory.make ("xvimagesink", null);

    if(sink != null)
    {
        sret = sink.set_state(Gst.State.READY);
        if(sret == Gst.StateChangeReturn.SUCCESS)
            return true;

        sink.set_state(Gst.State.NULL);
    }
    return false;
}

public int main (string[] args)
{
    Gst.Element src;
    Gst.Element sink;
    long embed_xid;
    Gst.StateChangeReturn sret;

    Gst.init(ref args);
    Gtk.init(ref args);

    var pipeline = new Gst.Pipeline("xvoverlay");
    src = Gst.ElementFactory.make ("v4l2src", null);

    //the device is /dev/video0 by default.
    //this next line is here for demonstration only
    src["device"] = "/dev/video0";

    if(find_video_sink(out sink) == false)
    {
        print("Couldn't find a working video sink.");
        return -1;
    }

    pipeline.add_many(src, sink);
    src.link(sink);


    var window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
    window.set_default_size (320, 240);
    window.set_title("GstVideoOverlay Gtk+ demo");
    window.delete_event.connect(() => { pipeline.set_state(Gst.State.NULL); Gtk.main_quit(); return true; });

    var video_window = new Gtk.DrawingArea();
    window.add(video_window);
    window.set_border_width(16);
    window.show_all();

    var overlay = sink as Gst.Video.Overlay;
    overlay.set_window_handle((uint*) ((Gdk.X11.Window)video_window.get_window ()).get_xid ());

    sret = pipeline.set_state (Gst.State.PLAYING);
    if (sret == Gst.StateChangeReturn.FAILURE)
        pipeline.set_state(Gst.State.NULL);
    else
        Gtk.main ();

    return 0;
}
