/* window.vala
 *
 * Copyright 2022 Daniel Svitan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace UnitConvertor {
    [GtkTemplate(ui = "/com/streamer272/UnitConvertor/window.ui")]
    public class Window : Gtk.ApplicationWindow {
        [GtkChild]
        private unowned Gtk.Entry convert_entry;
        [GtkChild]
        private unowned Gtk.Button convert_button;

        [GtkChild]
        private unowned Gtk.DropDown temp_dropdown_from;
        [GtkChild]
        private unowned Gtk.DropDown temp_dropdown_to;
    
        [GtkChild]
        private unowned Gtk.Box answer_box;
        [GtkChild]
        private unowned Gtk.Label answer_label;

        private Convertor[] convertors;
        private ushort convertor_index;

        public Window(Gtk.Application app) {
            Object(application: app);
            convert_entry.activate.connect(convert);
            convert_button.clicked.connect(convert);

            convertors = new Convertor[1];
            convertors[0] = new TempConvertor();
            convertors[0].init(temp_dropdown_from, temp_dropdown_to);

            convertor_index = 0;
        }

        public void convert() {
            answer_box.set("visible", true);

            float convert_value = float.parse(convert_entry.get_text());
            string result = convertors[convertor_index].convert(convert_value);
            answer_label.set("label", result);
        }
    }
}
