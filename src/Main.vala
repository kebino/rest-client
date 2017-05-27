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
            
            this.set_default_size(400,400);
            this.destroy.connect(Gtk.main_quit);

            var notebook = new Gtk.Notebook();
            var notebook_labels = new List<Gtk.Label>();
            
            notebook_labels.append(new Gtk.Label("Request"));
            notebook_labels.append(new Gtk.Label("Response"));
            
            var request_page = new RequestPage();

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.height_request = 350;
            scrolled.vexpand = true;

            var lbl_res_body = new Gtk.Label("");
            lbl_res_body.set_line_wrap(true);
            scrolled.add(lbl_res_body);
            
            //set submit callback function
            request_page.get_submit_button().clicked.connect(() => {

                string method = request_page.get_http_method();
                string url = request_page.get_url_text();
                var session = new Soup.Session();
                var message = new Soup.Message(method, url);
                
                if(message.get_uri() == null) {
                    request_page.set_status_text("Invalid URL");
                    return;
                }
                request_page.set_status_text("Waiting For Response");

                session.queue_message(message, (sess, mess) => {
                    request_page.set_status_text("");
                    lbl_res_body.label = (string)mess.response_body.flatten().data;
                    notebook.set_current_page(1);
                });
            });

            notebook.append_page(request_page, notebook_labels.nth_data(0));
            notebook.append_page(scrolled, notebook_labels.nth_data(1));
            this.add(notebook);
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