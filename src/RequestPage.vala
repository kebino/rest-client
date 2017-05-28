/*
* Copyright (c) 2011-2017 Mark Kevin Baltazar (https://github.com/kebino/rest-client)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Mark Kevin Baltazar <markkevinbaltazar@gmail.com>
*/

using Gtk;

namespace RestClient { 
    
    public class RequestPage : Gtk.Grid { 
        private ComboBoxText cb_http_methods;
        private Entry entry_url;
        private Entry entry_h_key;
        private Entry entry_h_val;
        private Label lbl_status;
        private Label lbl_header;
        private Label lbl_body;
        private Button add_header;
        private Button submit;
        private ScrolledWindow scrolled;
        private TextView txt_body;
        public List<KeyValue> key_value_list;

        public RequestPage() {
            set_border_width(12);
            column_spacing = 6;
            row_spacing = 6;
            orientation = Gtk.Orientation.VERTICAL;

            key_value_list = new List<KeyValue>();

            cb_http_methods = new ComboBoxText();
            cb_http_methods.append_text("GET");
            cb_http_methods.append_text("POST");
            cb_http_methods.append_text("PUT");
            cb_http_methods.append_text("DELETE");
            cb_http_methods.append_text("HEAD");
            cb_http_methods.append_text("OPTIONS");
            cb_http_methods.append_text("PATCH");
            
            cb_http_methods.active = 0;

            entry_url = new Entry();
            entry_url.placeholder_text = "Enter URL e.g. http://www.example.com";
            entry_url.width_request = 350;
            entry_url.hexpand = true;

            entry_h_key = new Entry();
            entry_h_key.placeholder_text = "Key";
            entry_h_key.hexpand = true;

            entry_h_val = new Entry();
            entry_h_val.placeholder_text = "Value";
            entry_h_val.hexpand = true;

            lbl_status = new Label("");
            lbl_status.set_line_wrap(true);

            lbl_header = new Label("<b>Headers</b>");
            lbl_header.set_use_markup(true);
            lbl_header.set_line_wrap(true);

            submit = new Button.with_label("Submit");
            add_header = new Button.with_label("Add");

            lbl_body = new Label("<b>Body</b>");
            lbl_body.set_use_markup(true);
            lbl_body.set_line_wrap(true);
            lbl_body.valign = Gtk.Align.START;

            txt_body = new TextView();
            txt_body.set_wrap_mode(Gtk.WrapMode.WORD);
            txt_body.hexpand = false;
            
            scrolled = new ScrolledWindow(null, null);
            scrolled.hexpand = false;
            scrolled.vexpand = false;
            
            scrolled.height_request = 200;
            scrolled.add(txt_body);

            //method url and submit
            attach(cb_http_methods, 0, 0, 1, 1);
            attach(entry_url, 1, 0, 2, 1);
            attach(submit, 3, 0, 1, 1);
            attach(lbl_status, 1, 1, 2, 1);
            //header
            attach(lbl_header, 0, 2, 1, 1);
            attach(entry_h_key, 1, 2, 1, 1);
            attach(entry_h_val, 2, 2, 1, 1);
            attach(add_header, 3, 2, 1, 1);
            //body
            attach(lbl_body, 0, 4, 1, 1);
            attach(scrolled, 1, 4, 2, 2);
            

            add_header.clicked.connect(add_header_clicked);
        }

        private void add_header_clicked() {
            if(entry_h_key.get_text() == "" || entry_h_val.get_text() == "") {
                lbl_status.label = "Key Value pair must not be empty";
                return;
            }
            lbl_status.label = "";

            var lbl_k = new Label(entry_h_key.get_text());
            var lbl_v = new Label(entry_h_val.get_text());
            var del = new Button.with_label("Remove");
            var kv = new KeyValue() { key_string = lbl_k.label, value_string = lbl_v.label };
            
            key_value_list.append(kv);

            insert_row(3);
            attach_next_to(lbl_k, entry_h_key, Gtk.PositionType.BOTTOM, 1, 1);
            attach_next_to(lbl_v, entry_h_val, Gtk.PositionType.BOTTOM, 1, 1);
            attach_next_to(del, add_header, Gtk.PositionType.BOTTOM, 1, 1);

            del.clicked.connect(() => {
                remove(lbl_k);
                remove(lbl_v);
                key_value_list.remove(kv);

                //  stdout.printf("number of headers: %u\n", key_value_list.length());
                remove(del);
            });

            entry_h_key.set_text("");
            entry_h_val.set_text("");
            show_all();
            //  stdout.printf("number of headers: %u\n", key_value_list.length());
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

        public string get_body_text() {
            return txt_body.buffer.text;
        }
    }
}