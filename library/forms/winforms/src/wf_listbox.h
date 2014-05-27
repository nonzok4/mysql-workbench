/* 
 * Copyright (c) 2009, 2014, Oracle and/or its affiliates. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; version 2 of the
 * License.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301  USA
 */

#pragma once

namespace MySQL {
  namespace Forms {

    public class ListBoxWrapper : public ViewWrapper
    {
    protected:
      ListBoxWrapper(mforms::ListBox *backend);

      static bool create(mforms::ListBox *backend, bool multi_select);
      static void clear(mforms::ListBox *backend);
      static void set_heading(mforms::ListBox *backend, const std::string &text);
      static void add_items(mforms::ListBox *backend, const std::list<std::string> &items);
      static size_t add_item(mforms::ListBox *backend, const std::string &item);
      static void remove_indices(mforms::ListBox *backend, const std::vector<size_t> &indices);
      static void remove_index(mforms::ListBox *backend, size_t index);
      static std::string get_text(mforms::ListBox *backend);
      static void set_index(mforms::ListBox *backend, ssize_t index);
      static ssize_t get_index(mforms::ListBox *backend);
      static std::vector<size_t> get_selected_indices(mforms::ListBox *backend);
    public:
      static void init();
    };
  }
}