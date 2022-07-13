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
            dropdown_to.set("selected", 1);
            convert_entry.activate.connect(convert);
            convert_button.clicked.connect(convert);
        }

        public void convert() {
            answer_box.set("visible", true);

            uint from = dropdown_from.get_selected();
            uint to = dropdown_to.get_selected();

            float convert_value = float.parse(convert_entry.get_text());

            string format(float number) {
                return "%.1f".printf(number);
            }

            if (from == to) {
                answer_label.set("label", format(convert_value));
                return;
            }
            else if (from == 0) {
                if (to == 1) {
                    float fahrenheit = convert_value * 9 / 5 + 32;
                    answer_label.set("label", format(fahrenheit));
                }
                else if (to == 2) {
                    float kelvin = convert_value + 273.15f;
                    answer_label.set("label", format(kelvin));
                }
            }
            else if (from == 1) {
                if (to == 0) {
                    float celsius = (convert_value - 32) * 5 / 9;
                    answer_label.set("label", format(celsius));
                }
                else if (to == 2) {
                    float kelvin = (convert_value - 32) * 5 / 9 + 273.15f;
                    answer_label.set("label", format(kelvin));
                }
            }
            else if (from == 2) {
                if (to == 0) {
                    float celsius = convert_value - 273.15f;
                    answer_label.set("label", format(celsius));
                }
                else if (to == 1) {
                    float fahrenheit = (convert_value - 273.15f) * 9 / 5 + 32;
                    answer_label.set("label", format(fahrenheit));
                }
            }
        }
    }
}
