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
        private unowned Gtk.Box units_box;
        [GtkChild]
        private unowned Gtk.DropDown units_dropdown;
        [GtkChild]
        private unowned Gtk.Button units_button;

        [GtkChild]
        private unowned Gtk.Box convert_box;
        [GtkChild]
        private unowned Gtk.Entry convert_entry;
        [GtkChild]
        private unowned Gtk.Button swap_button;
        [GtkChild]
        private unowned Gtk.Button convert_button;

        [GtkChild]
        private unowned Gtk.DropDown temp_dropdown_from;
        [GtkChild]
        private unowned Gtk.DropDown temp_dropdown_to;
        [GtkChild]
        private unowned Gtk.DropDown mass_dropdown_from;
        [GtkChild]
        private unowned Gtk.DropDown mass_dropdown_to;
    
        [GtkChild]
        private unowned Gtk.Box answer_box;
        [GtkChild]
        private unowned Gtk.Label answer_label;
        [GtkChild]
        private unowned Gtk.Button answer_copy_button;

        private Convertor[] convertors;
        private uint convertor_index;

        public Window(Gtk.Application app) {
            Object(application: app);

            units_button.clicked.connect(change_units);
            convert_entry.activate.connect(convert);
            convert_entry.changed.connect(hide_answer_box);
            swap_button.clicked.connect(swap);
            convert_button.clicked.connect(convert);
            answer_copy_button.clicked.connect(copy);

            temp_dropdown_from.notify["selected"].connect(hide_answer_box);

            convertors = new Convertor[2];
            convertors[0] = new TempConvertor();
            convertors[0].init(temp_dropdown_from, temp_dropdown_to);
            convertors[1] = new MassConvertor();
            convertors[1].init(mass_dropdown_from, mass_dropdown_to);

            convertor_index = 0;
        }

        public void change_units() {
            /*
             * 0 = Temperature
             * 1 = Mass
             */

            units_box.hide();
            convert_box.show();
            answer_box.hide();

            convertor_index = units_dropdown.get_selected();
            switch (convertor_index) {
            case 0:
                temp_dropdown_from.show();
                temp_dropdown_to.show();
                mass_dropdown_from.hide();
                mass_dropdown_to.hide();
                break;
            case 1:
                temp_dropdown_from.hide();
                temp_dropdown_to.hide();
                mass_dropdown_from.show();
                mass_dropdown_to.show();
                break;
            default:
                units_box.show();
                convert_box.hide();
                break;
            }
        }

        public void back_to_change_units() {
            units_box.show();
            convert_box.hide();
            answer_box.hide();
        }

        public void hide_answer_box() {
            if (answer_box.is_visible()) {
                answer_box.hide();
            }
        }

        public void swap() {
            convertors[convertor_index].swap();
        }

        public void convert() {
            answer_box.set("visible", true);

            float convert_value = float.parse(convert_entry.get_text());
            string result = convertors[convertor_index].convert(convert_value);
            answer_label.set("label", result);
        }

        public void copy() {
            Gdk.Clipboard clipboard = Gdk.Display.get_default().get_clipboard();
            clipboard.set_text(answer_label.get_text());
        }
    }
}
