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

            //create stack for request and response
            var notebook = new Gtk.Stack();
            notebook.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            notebook.set_transition_duration(400);
            
            string REQUEST_TITLE = "Request";
            string RESPONSE_TITLE = "Response";
            
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
                    notebook.set_visible_child_name(RESPONSE_TITLE);
                });
            });

            notebook.add_titled(request_page, REQUEST_TITLE, REQUEST_TITLE);
            notebook.add_titled(response_page, RESPONSE_TITLE, RESPONSE_TITLE);
            
            //create the stack switcher
            var sw = new Gtk.StackSwitcher();
            sw.stack = notebook;
            sw.halign = Gtk.Align.CENTER;
            sw.vexpand = false;
            
            //put the stack and stack switcher to box
            //then add the box to window
            var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            vbox.pack_start(sw, false, false, 12);
            vbox.pack_start(notebook, true, true,0);
            this.add(vbox);
        }

        public static int main(string[] args) {
            Gtk.init(ref args);
            var css_provider = new Gtk.CssProvider();
            try {
                //  css_provider.load_from_path("data/style.css");
                css_provider.load_from_buffer(Stylesheet.STYLE.data);
            }
            catch(Error e) {
                warning("Error loading css: %s\n", e.message);
            }
            Gtk.StyleContext.add_provider_for_screen(
                Gdk.Screen.get_default(),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
            var app = new Application();
            app.show_all();
            Gtk.main();
            return 0;
        }
    }
}