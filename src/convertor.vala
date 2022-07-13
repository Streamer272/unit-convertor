/* convertor.vala
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
    public abstract class Convertor : Object {
        private unowned Gtk.DropDown dropdown_from;
        private unowned Gtk.DropDown dropdown_to;

        construct {
            dropdown_from = null;
            dropdown_to = null;
        }

        public Convertor init(Gtk.DropDown dropdown_from, Gtk.DropDown dropdown_to) {
            this.dropdown_from = dropdown_from;
            this.dropdown_to = dropdown_to;
            dropdown_from.set("selected", 0);
            dropdown_to.set("selected", 1);
            return this;
        }

        public void swap() {
            uint temp = dropdown_from.get_selected();
            dropdown_from.set("selected", dropdown_to.get_selected());
            dropdown_to.set("selected", temp);
        }

        protected uint get_from() {
            return dropdown_from.get_selected();
        }
        protected uint get_to() {
            return dropdown_to.get_selected();
        }

        protected string format(float number) {
            return "%.1f".printf(number);
        }

        public abstract string convert(float convert_value);
    }

    public class TempConvertor : Convertor {
        public override string convert(float convert_value) {
            uint from = get_from();
            uint to = get_to();

            /*
             * 0 = Celsius
             * 1 = Fahrenheit
             * 2 = Kelvin
             */

            if (from == to) {
                return format(convert_value);
            }
            
            switch (from) {
            case 0:
                switch (to) {
                case 1:
                    return format(convert_value * 9 / 5 + 32);
                case 2:
                    return format(convert_value + 273.15f);
                }
                break;
            case 1:
                switch (to) {
                case 0:
                    return format((convert_value - 32) * 5 / 9);
                case 2:
                    return format((convert_value - 32) * 5 / 9 + 273.15f);
                }
                break;
            case 2:
                switch (to) {
                case 0:
                    return format(convert_value - 273.15f);
                case 1:
                    return format((convert_value - 273.15f) * 9 / 5 + 32);
                }
                break;
            }

            return "";
        }
    }

    public class MassConvertor : Convertor {
        public override string convert(float convert_value) {
            uint from = get_from();
            uint to = get_to();

            /*
             * 0 = Grams
             * 1 = Kilograms
             * 2 = Tons
             * 3 = Ounces
             * 4 = Pounds
             */

            if (from == to) {
                return format(convert_value);
            }

            switch (from) {
            case 0:
                switch (to) {
                case 1:
                    return format(convert_value / 1000);
                case 2:
                    return format(convert_value / 1000000);
                case 3:
                    return format(convert_value / 28.34952f);
                case 4:
                    return format(convert_value / 453.59237f);
                }
                break;
            case 1:
                switch (to) {
                case 0:
                    return format(convert_value * 1000);
                case 2:
                    return format(convert_value / 1000);
                case 3:
                    return format(convert_value * 35.27396f);
                case 4:
                    return format(convert_value * 2.20462f);
                }
                break;
            case 2:
                switch (to) {
                case 0:
                    return format(convert_value * 1000000);
                case 1:
                    return format(convert_value * 1000);
                case 3:
                    return format(convert_value * 35273.96195f);
                case 4:
                    return format(convert_value * 2204.62262f);
                }
                break;
            case 3:
                switch (to) {
                case 0:
                    return format(convert_value * 28.34952f);
                case 1:
                    return format(convert_value / 35.27396f);
                case 2:
                    return format(convert_value / 35273.96195f);
                case 4:
                    return format(convert_value / 16);
                }
                break;
            case 4:
                switch (to) {
                case 0:
                    return format(convert_value / 2.20462f);
                case 1:
                    return format(convert_value / 2.20462f);
                case 2:
                    return format(convert_value / 2204.62262f);
                case 3:
                    return format(convert_value * 16);
                }
                break;
            }

            return "";
        }
    }
}
