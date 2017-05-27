using Gtk;

namespace RestClient { 
    
    public class RequestPage : Gtk.Grid { 
        private ComboBoxText cb_http_methods;
        private Entry entry_url;
        private Label lbl_status;
        private Button submit;

        public RequestPage() {
            set_border_width(12);
            column_spacing = 6;
            row_spacing = 6;

            cb_http_methods = new ComboBoxText();
            cb_http_methods.append_text("GET");
            cb_http_methods.append_text("POST");
            cb_http_methods.append_text("PUT");
            cb_http_methods.append_text("DELETE");
            cb_http_methods.active = 0;

            entry_url = new Entry();
            entry_url.placeholder_text = "Enter URL e.g. http://wwww.example.com";
            entry_url.width_request = 350;
            entry_url.hexpand = true;

            lbl_status = new Label("");
            lbl_status.set_line_wrap(true);

            submit = new Button.with_label("Submit");

            attach(cb_http_methods, 0, 0, 1, 1);
            attach(entry_url, 1, 0, 1, 1);
            attach(submit, 2, 0, 1, 1);
            attach(lbl_status, 1, 1, 1, 1);
        }

        public string get_http_method() {
            return cb_http_methods.get_active_text();
        }

        public string get_url_text() {
            return entry_url.get_text();
        }

        public Button get_submit_button() {
            return submit;
        }

        public void set_status_text(string status_text) {
            lbl_status.label = status_text;
        }
    }
}