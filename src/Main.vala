namespace RestClient { 
    
    public class Application : Gtk.Window { 

        public Application() {

            string ENTRY_PLACEHOLDER_TEXT = "Enter URL e.g. http://wwww.example.com";

            this.title = "Rest Client";
            this.window_position = Gtk.WindowPosition.CENTER;
            this.set_border_width(12);
            this.destroy.connect(Gtk.main_quit);

            //Combobox with http methods
            var cb = new Gtk.ComboBoxText();
            cb.append_text("GET");
            cb.append_text("POST");
            cb.append_text("PUT");
            cb.append_text("DELETE");
            cb.active = 0;

            //text entry for entering the url
            var entry = new Gtk.Entry();
            entry.placeholder_text = ENTRY_PLACEHOLDER_TEXT;
            entry.width_request = 350;
            entry.hexpand = true;

            var lbl_response = new Gtk.Label("");
            lbl_response.set_line_wrap(true);

            //submit button
            var submit = new Gtk.Button.with_label("Submit");
            submit.clicked.connect(() => {

                string method = cb.get_active_text();
                string url = entry.get_text();
                var session = new Soup.Session();
                var message = new Soup.Message(method, url);
                
                if(message.get_uri() == null) {
                    lbl_response.label = "Invalid URL";
                    return;
                }
                lbl_response.label = "Waiting For Response";

                session.queue_message(message, (sess, mess) => {
                    lbl_response.label = "Response %u".printf(mess.status_code);
                    stdout.printf("Response Body: \n%s\n", (string)mess.response_body.flatten().data);    
                });
            });

            //Grid
            var grid = new Gtk.Grid();
            grid.column_spacing = 6;
            grid.row_spacing = 6;

            grid.attach(cb, 0, 0, 1, 1);
            grid.attach(entry, 1, 0, 1, 1);
            grid.attach(submit, 2, 0, 1, 1);
            grid.attach(lbl_response, 1, 1, 1, 1);

            this.add(grid);
        }

        public static int main(string[] args) {
            Gtk.init(ref args);
            var app = new Application();
            app.show_all();
            Gtk.main();
            return 0;
        }
    }
}