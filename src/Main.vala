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

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.height_request = 350;
            scrolled.vexpand = true;
            var label_response = new Gtk.Label("");
            label_response.set_line_wrap(true);
            scrolled.add(label_response);
            
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
                    label_response.label = (string)mess.response_body.flatten().data;
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
            grid.attach(scrolled, 0, 2, 3, 2);

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