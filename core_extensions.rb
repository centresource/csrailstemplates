module Rails
  module Generators
    module Actions

      require 'erb'

      attr_reader :template_options

      def initialize_template
        @template_options = {}
      end

      def load_options
        @template_options[:db_adapters] = {'postgres' => 'postgresql', 'mysql' => 'mysql2', 'sqlite' => 'sqlite3'}
        @template_options[:db_gems] = {'postgres' => 'pg', 'mysql' => 'mysql2', 'sqlite' => 'sqlite3'}
        @template_options[:db_choice] = ask("What db will you be using?", :limited_to => ['postgres', 'mysql', 'sqlite'])

        unless @template_options[:db_choice] == 'sqlite'
          @template_options[:username] = ask "What is your #{@template_options[:db_choice]} database username?"
          @template_options[:password] = ask "What is your #{@template_options[:db_choice]} database password? (leave blank for none)"
        end

        if yes? 'Will you be using Factory Girl? [y/n]'
          @template_options[:factory_girl] = true
        elsif yes? 'Ok then, how about Object Daddy? [y/n]'
          @template_options[:object_daddy] = true
          say 'Hello, Jeremy.'
        end

        if yes? 'Will you be using Authlogic? [y/n]'
          @template_options[:authlogic] = true
        elsif yes? 'Will you be using ActiveAdmin? [y/n]'
          @template_options[:active_admin] = true
          @template_options[:devise] = true
        elsif yes? 'Ok then, how about Devise? [y/n]'
          @template_options[:devise] = true
        end

      end

      def recipe(name)
        File.join File.dirname(__FILE__), 'recipes', "#{name}.rb"
      end

      def load_template(name, group)
        path = File.expand_path name, template_path(group)
        # File.read path
        content = ERB.new(File.read path)
        content.result(binding)
      end

      def template_path(name)
        File.join(File.dirname(__FILE__), 'templates', name)
      end

    end
  end
end
