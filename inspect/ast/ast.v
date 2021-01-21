module ast

import v.ast
import v.parser
import v.pref
import v.table

// V 0.2.1 71d3d4c
pub fn inspect_files(paths []string, prefs &pref.Preferences) {
	global_scope := ast.Scope{
		parent: 0
	}
	for path in paths {
		f := parser.parse_file(path, table.new_table(), .parse_comments, prefs, &global_scope)
		mut p := new_printer()
		p.print_file(f)
	}
}

pub struct Printer {
mut:
	indent_n int
}

pub fn new_printer() Printer {
	return Printer {
	}
}

fn (mut p Printer) println(text string) {
	for s in text.split_into_lines() {
		println('\t'.repeat(p.indent_n) + s)
	}
}

fn (mut p Printer) print_expr(expr ast.Expr) {
	p.println(expr.str())
}

pub fn (mut p Printer) print_file(file ast.File) {
	p.println('File{')
	p.println('}')
}