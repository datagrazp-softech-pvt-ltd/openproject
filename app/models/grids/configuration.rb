#-- encoding: UTF-8

#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

class Grids::Configuration
  class << self
    include OpenProject::StaticRouting::UrlHelpers

    def register_grid(grid,
                      page)
      @grid_register ||= {}

      @grid_register[grid] = page
    end

    def registered_grids
      registered_grid_by_klass.keys
    end

    def registered_pages
      registered_grid_by_page.keys
    end

    def grid_for_page(page)
      registered_grid_by_page[page] || Grid
    end

    def grid_for_class(klass)
      registered_grid_by_klass[klass]
    end

    def registered_grid?(klass)
      registered_grid_by_klass.key?(klass)
    end

    def register_widget(identifier, grid_classes)
      @widget_register ||= {}

      @widget_register[identifier] = Array(grid_classes)
    end

    def allowed_widget?(grid, identifier)
      grid_classes = registered_widget_by_identifier[identifier]

      (grid_classes || []).include?(grid)
    end

    protected

    def registered_grid_by_page
      if @registered_grid_by_page && @registered_grid_by_page.length == @grid_register.length
        @registered_grid_by_page
      else
        @registered_grid_by_page = @grid_register.map { |klass, path| [send(path), klass.constantize] }.to_h
      end
    end

    def registered_grid_by_klass
      if @registered_grid_by_klass && @registered_grid_by_klass.length == @grid_register.length
        @registered_grid_by_klass
      else
        @registered_grid_by_klass = @grid_register.map { |klass, path| [klass.constantize, send(path)] }.to_h
      end
    end

    def registered_widget_by_identifier
      if @registered_widget_by_identifier && @registered_widget_by_identifier.length == @widget_register.length
        @registered_widget_by_identifier
      else
        @registered_widget_by_identifier = @widget_register
                                           .map { |identifier, classes| [identifier, classes.map(&:constantize)] }
                                           .to_h
      end
    end
  end
end

Grids::Configuration.register_grid('MyPageGrid', 'my_page_path')
Grids::Configuration.register_widget('work_packages_assigned', 'MyPageGrid')
Grids::Configuration.register_widget('work_packages_accountable', 'MyPageGrid')
Grids::Configuration.register_widget('work_packages_watched', 'MyPageGrid')
Grids::Configuration.register_widget('work_packages_created', 'MyPageGrid')
Grids::Configuration.register_widget('work_packages_calendar', 'MyPageGrid')
Grids::Configuration.register_widget('time_entries_current_user', 'MyPageGrid')
Grids::Configuration.register_widget('documents', 'MyPageGrid')
Grids::Configuration.register_widget('news', 'MyPageGrid')

Grids::Configuration.register_grid('BoardGrid', 'boards_path')
Grids::Configuration.register_widget('work_package_query', 'BoardGrid')

