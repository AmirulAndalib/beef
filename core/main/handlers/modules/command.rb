#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
module BeEF
  module Core
    module Handlers
      module Modules
        module Command
          # Adds the command module instructions to a hooked browser's http response.
          # @param [Object] command Command object
          # @param [Object] hooked_browser Hooked Browser object
          def add_command_instructions(command, hooked_browser)
            if hooked_browser.nil?
              (print_error 'hooked_browser is nil'
               return)
            end
            if hooked_browser.session.nil?
              (print_error 'hooked_browser.session is nil'
               return)
            end
            if command.nil?
              (print_error 'hooked_browser is nil'
               return)
            end
            if command.command_module_id.nil?
              (print_error 'hooked_browser.command_module_id is nil'
               return)
            end

            config = BeEF::Core::Configuration.instance
            # @note get the command module
            command_module = BeEF::Core::Models::CommandModule.where(id: command.command_module_id).first
            if command_module.nil?
              (print_error 'command_module is nil'
               return)
            end
            if command_module.path.nil?
              (print_error 'command_module.path is nil'
               return)
            end

            if command_module.path.match(/^Dynamic/)
              command_module = BeEF::Modules::Commands.const_get(command_module.path.split('/').last.capitalize).new
            else
              key = BeEF::Module.get_key_by_database_id(command.command_module_id)
              if key.nil?
                (print_error "Could not find command module with ID #{command.command_module_id}"
                 return)
              end
              command_module = BeEF::Core::Command.const_get(config.get("beef.module.#{key}.class")).new(key)
            end

            command_module.command_id = command.id
            command_module.session_id = hooked_browser.session
            command_module.build_datastore(command.data)
            command_module.pre_send

            build_missing_beefjs_components(command_module.beefjs_components) unless command_module.beefjs_components.empty?

            ws = BeEF::Core::Websocket::Websocket.instance

            if config.get('beef.extension.evasion.enable')
              evasion = BeEF::Extension::Evasion::Evasion.instance
              @output = evasion.obfuscate(command_module.output)
            else
              @output = command_module.output
            end

            # TODO: antisnatchor: remove this gsub crap adding some hook packing.
            if config.get('beef.http.websocket.enable') && ws.getsocket(hooked_browser.session)
              # content = command_module.output.gsub('//
              # //
              # //   Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
              # //   Browser Exploitation Framework (BeEF) - https://beefproject.com
              # //   See the file 'doc/COPYING' for copying permission
              # //
              # //', "")
              ws.send(@output, hooked_browser.session)
            else
              @body << (@output + "\n\n")
            end
            # @note prints the event to the console
            if BeEF::Settings.console?
              name = command_module.friendlyname || kclass
              print_info "Hooked browser [id:#{hooked_browser.id}, ip:#{hooked_browser.ip}] has been sent instructions from command module [cid:#{command.id}, mod: #{command.command_module_id}, name:'#{name}']"
            end

            # @note flag that the command has been sent to the hooked browser
            command.instructions_sent = true
            command.save!
          end
        end
      end
    end
  end
end
