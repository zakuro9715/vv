module main

import cli { Command }
import os { system, dir }
import v.vmod

fn v(cmd string) int {
	return system('VCOLORS=always ' + @VEXE + ' $cmd')
}

fn vv(cmd string) int {
	return system('vv $cmd')
}

const (
	ci_command = Command{
		name: 'ci'
		description: 'Run ci tests'
		commands: [
			Command{
				name: 'all'
				description: 'test-fixed'
				execute: fn (cmd Command) ? {
					exit(vv('ci cleancode') + vv('ci fixed') + vv('ci fmt') + vv('ci examples') +
						vv('ci tools') + vv('ci md'))
				}
			},
			Command{
				name: 'fmt'
				description: 'test-fmt'
				execute: fn (cmd Command) ? {
					exit(v('test-fmt'))
				}
			},
			Command{
				name: 'cleancode'
				description: 'test-cleancode'
				execute: fn (cmd Command) ? {
					exit(v('test-cleancode'))
				}
			},
			Command{
				name: 'md'
				description: 'check-md'
				execute: fn (cmd Command) ? {
					exit(v('run ${dir(@VEXE)}/cmd/tools/check-md.v -all'))
				}
			},
			Command{
				name: 'fixed'
				description: 'test-fixed'
				execute: fn (cmd Command) ? {
					exit(v('test-fixed'))
				}
			},
			Command{
				name: 'examples'
				description: 'build-examples'
				execute: fn (cmd Command) ? {
					exit(v('build-examples'))
				}
			},
			Command{
				name: 'tools'
				description: 'build-tools'
				execute: fn (cmd Command) ? {
					exit(v('build-tools'))
				}
			},
		]
	}
)

fn new_app() Command {
	mod := vmod.decode(@VMOD_FILE) or { panic(err) }
	mut app := Command{
		name: mod.name
		description: mod.description
		version: mod.version
		disable_flags: true
		commands: [
			Command{
				name: 'bootstrap'
				description: 'make V'
				execute: fn (cmd Command) ? {
					exit(system('cd ${dir(@VEXE)} && make'))
				}
			},
			Command{
				name: 'self'
				description: 'self compilation'
				execute: fn (cmd Command) ? {
					mut code := v('self')
					println('Compiling vv...')
					code += v(dir(@FILE))
					exit(code)
				}
			},
			ci_command,
			inspect_command,
		]
	}
	app.setup()
	return app
}

fn main() {
	mut app := new_app()
	app.parse(os.args)
}
