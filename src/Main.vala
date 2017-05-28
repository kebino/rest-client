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

            //set window params
            this.title = "Rest Client";
            this.window_position = Gtk.WindowPosition.CENTER;
            this.set_default_size(400,400);
            this.destroy.connect(Gtk.main_quit);

            //create notebook for request and response
            var notebook = new Gtk.Notebook();
            var notebook_labels = new List<Gtk.Label>();
            
            notebook_labels.append(new Gtk.Label("Request"));
            notebook_labels.append(new Gtk.Label("Response"));
            
            var request_page = new RequestPage();
            var response_page = new ResponsePage();
            
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

                foreach (var header in request_page.key_value_list) {
                    message.request_headers.append(header.key_string, header.value_string);
                }
                string str_body = request_page.get_body_text();
                message.request_body.append( Soup.MemoryUse.COPY, str_body.data);

                session.queue_message(message, (sess, mess) => {
                    request_page.set_status_text("");
                    response_page.set_response_code_text("%u".printf(mess.status_code));
                    response_page.set_response_body_text((string)mess.response_body.flatten().data);
                    notebook.set_current_page(1);
                });
            });

            notebook.append_page(request_page, notebook_labels.nth_data(0));
            notebook.append_page(response_page, notebook_labels.nth_data(1));
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