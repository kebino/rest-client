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
        private Label lbl_status;
        private Label lbl_body;
        private Button submit;
        private ScrolledWindow scrolled;
        private Box box_hdr;
        private TextView txt_body;
        public RequestHeaderWidget widget_request_header { get; set; }

        public RequestPage() {
            set_border_width(12);
            column_spacing = 6;
            row_spacing = 6;
            orientation = Gtk.Orientation.VERTICAL;

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
            //  entry_url.width_request = 350;
            entry_url.hexpand = true;

            lbl_status = new Label("");
            lbl_status.set_line_wrap(true);

            submit = new Button.with_label("Submit");
            submit.get_style_context().add_class("blue-color");
            submit.width_request = 70;

            lbl_body = new Label("<b>Body</b>");
            lbl_body.set_use_markup(true);
            lbl_body.set_line_wrap(true);
            lbl_body.valign = Gtk.Align.START;

            txt_body = new TextView();
            txt_body.set_wrap_mode(Gtk.WrapMode.WORD);
            txt_body.hexpand = false;
            txt_body.vexpand = true;
            
            scrolled = new ScrolledWindow(null, null);
            scrolled.hexpand = false;
            scrolled.vexpand = true;
            
            scrolled.height_request = 300;
            scrolled.add(txt_body);

            //box for http method, url entry, and submit
            var box1 = new Box(Gtk.Orientation.HORIZONTAL, 6);
            box1.add(cb_http_methods);
            box1.add(entry_url);
            box1.add(submit);

            //header and body stack
            box_hdr = new Box(Gtk.Orientation.VERTICAL, 6);
            widget_request_header = new RequestHeaderWidget();
            widget_request_header.btn_add.clicked.connect(add_header_clicked);
            box_hdr.add(widget_request_header);

            var stack = new Stack();
            stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            stack.set_transition_duration(400);
            stack.add_titled(box_hdr, "Headers", "Headers");
            stack.add_titled(scrolled, "Body", "Body");

            //the stack switcher
            var switcher = new StackSwitcher();
            switcher.stack = stack;

            //add the stackswitcher and stack to a box
            var box2 = new Box(Gtk.Orientation.VERTICAL, 0);
            box2.pack_start(switcher, false, false, 3);
            box2.pack_start(stack, true, true, 0);

            //add all boxes
            this.add(box1);
            this.add(box2);
            
        }

        private void add_header_clicked() {
            if(widget_request_header.entry_key.get_text() == "" || widget_request_header.entry_value.get_text() == "") {
                //lbl_status.label = "Key Value pair must not be empty";
                return;
            }
            //  lbl_status.label = "";

            var lbl_k = new Entry();
            lbl_k.set_text(widget_request_header.entry_key.get_text());
            lbl_k.editable = false;
            lbl_k.hexpand = true;

            var lbl_v = new Entry();
            lbl_v.set_text(widget_request_header.entry_value.get_text());
            lbl_v.editable = false;
            lbl_v.hexpand = true;

            var del = new Button.with_label("Remove");
            del.get_style_context().add_class("red-color");

            var kv = new KeyValue();
            kv.key_string = lbl_k.get_text(); 
            kv.value_string = lbl_v.get_text(); 
            
            widget_request_header.key_value_list.append(kv);

            var row_box = new Box(Gtk.Orientation.HORIZONTAL, 6);
            row_box.add(lbl_k);
            row_box.add(lbl_v);
            row_box.add(del);

            box_hdr.add(row_box);
            del.clicked.connect(() => {
                widget_request_header.key_value_list.remove(kv);

                stdout.printf("Delete, number of headers: %u\n", widget_request_header.key_value_list.length());
                box_hdr.remove(row_box);
            });

            widget_request_header.entry_key.set_text("");
            widget_request_header.entry_value.set_text("");
            show_all();
            stdout.printf("Add, number of headers: %u\n", widget_request_header.key_value_list.length());
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