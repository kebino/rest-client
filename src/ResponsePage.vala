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
    
    public class ResponsePage : Gtk.Grid { 
        
        private ScrolledWindow scrolled_res_body;
        private Label lbl_res_code_title;
        private Label lbl_res_code;
        private Label lbl_res_body_title;
        private Label lbl_res_body;

        public ResponsePage() {
            set_border_width(12);
            column_spacing = 6;
            row_spacing = 6;

            scrolled_res_body = new ScrolledWindow(null, null);
            scrolled_res_body.height_request = 350;
            scrolled_res_body.vexpand = true;
            scrolled_res_body.hexpand = true;

            lbl_res_code = new Label("");
            lbl_res_code.set_line_wrap(true);

            lbl_res_code_title = new Label("<b>Response Code</b>");
            lbl_res_code_title.set_use_markup(true);
            lbl_res_code_title.set_line_wrap(true);

            lbl_res_body = new Label("");
            lbl_res_body.set_line_wrap(true);

            lbl_res_body_title = new Label("<b>Response Body</b>");
            lbl_res_body_title.set_use_markup(true);
            lbl_res_body_title.set_line_wrap(true);

            scrolled_res_body.add(lbl_res_body);

            attach(lbl_res_code_title, 0, 0, 1, 1);
            attach(lbl_res_code, 0, 1, 1, 1);
            attach(lbl_res_body_title, 0, 2, 1, 1);
            attach(scrolled_res_body, 0, 3, 1, 1);
        }

        public void set_response_body_text(string body_text) {
            lbl_res_body.label = body_text;
        }

        public void set_response_code_text(string res_code_text) {
            lbl_res_code.label = res_code_text;
        }
    }
}