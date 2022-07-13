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
        private unowned Gtk.Entry convert_value;
        [GtkChild]
        private unowned Gtk.DropDown dropdown_from;
        [GtkChild]
        private unowned Gtk.DropDown dropdown_to;
        [GtkChild]
        private unowned Gtk.Button convert_button;
        [GtkChild]
        private unowned Gtk.Box answer_box;
        [GtkChild]
        private unowned Gtk.Label answer_label;

        public Window(Gtk.Application app) {
            Object(application: app);
            this.dropdown_to.set("selected", 1);
            this.convert_value.activate.connect(this.convert);
            this.convert_button.clicked.connect(this.convert);
        }

        public void convert() {
            message("converting!!");
        }
    }
}
