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
    [GtkTemplate(ui = "/com/streamer272/UnitConvertor/gtk/window.ui")]
    public class Window : Gtk.ApplicationWindow {
        [GtkChild]
        private unowned Gtk.Button go_home_button;

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
        private unowned Gtk.DropDown len_dropdown_from;
        [GtkChild]
        private unowned Gtk.DropDown len_dropdown_to;
        [GtkChild]
        private unowned Gtk.DropDown vol_dropdown_from;
        [GtkChild]
        private unowned Gtk.DropDown vol_dropdown_to;

        [GtkChild]
        private unowned Gtk.Box answer_box;
        [GtkChild]
        private unowned Gtk.Label answer_label;
        [GtkChild]
        private unowned Gtk.Button answer_copy_button;

        private Convertor[] convertors;
        private uint convertor_index;

        private string old_convert_entry_text = "0";

        public Window(Gtk.Application app) {
            Object(application: app);

            go_home_button.clicked.connect(back_to_choose_units);
            units_button.clicked.connect(change_units);
            convert_entry.activate.connect(convert);
            convert_entry.changed.connect(on_input_change);
            swap_button.clicked.connect(swap);
            convert_button.clicked.connect(convert);
            answer_copy_button.clicked.connect(copy);

            temp_dropdown_from.notify["selected"].connect(hide_answer_box);
            temp_dropdown_to.notify["selected"].connect(hide_answer_box);
            mass_dropdown_from.notify["selected"].connect(hide_answer_box);
            mass_dropdown_to.notify["selected"].connect(hide_answer_box);

            SimpleAction swap_action = new SimpleAction("swap", null);
            swap_action.activate.connect(swap);
            app.add_action(swap_action);
            app.set_accels_for_action("app.swap", {"<primary>w"});

            SimpleAction convert_action = new SimpleAction("convert", null);
            convert_action.activate.connect(convert);
            app.add_action(convert_action);
            app.set_accels_for_action("app.convert", {"<primary>Return"});

            SimpleAction back_action = new SimpleAction("back", null);
            back_action.activate.connect(back_to_choose_units);
            app.add_action(back_action);
            app.set_accels_for_action("app.back", {"<primary>Escape"});

            SimpleAction copy_action = new SimpleAction("copy", null);
            copy_action.activate.connect(copy);
            app.add_action(copy_action);
            app.set_accels_for_action("app.copy", {"<primary>x"});

            convertors = {
                new TempConvertor().init(temp_dropdown_from, temp_dropdown_to),
                new MassConvertor().init(mass_dropdown_from, mass_dropdown_to),
                new LengthConvertor().init(len_dropdown_from, len_dropdown_to),
                new VolumeConvertor().init(vol_dropdown_from, vol_dropdown_to)
            };
            convertor_index = 0;
        }

        public void change_units() {
            /*
             * 0 = Temperature
             * 1 = Mass
             * 2 = Length
             */

            go_home_button.show();
            units_box.hide();
            convert_box.show();
            answer_box.hide();

            convertor_index = units_dropdown.get_selected();
            for (int i = 0; i < convertors.length; i++) {
                convertors[i].hide();
            }
            convertors[convertor_index].show();

            convert_entry.grab_focus();
        }

        public void back_to_choose_units() {
            go_home_button.hide();
            units_box.show();
            convert_box.hide();
            answer_box.hide();
            old_convert_entry_text = "0";
            convert_entry.get_buffer().set("text", "".data);
        }

        public void on_input_change() {
            hide_answer_box();

            string current_text = convert_entry.get_text();
            Regex regex = /[^\.0123456789]/i;
            MatchInfo mi;
            regex.match_all(current_text, 0, out mi);
            if (mi.fetch_all().length > 0) {
                convert_entry.set("text", old_convert_entry_text.data);
            }
            else {
                old_convert_entry_text = current_text;
            }
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
