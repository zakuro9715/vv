module ast

import v.ast

pub fn (mut b StringBuilder) stmts(stmts ...ast.Stmt) {
	n := stmts.len
	b.begin_array(n)
	for stmt in stmts {
		b.stmt(stmt)
		b.array_comma(n)
	}
	b.end_array(n)
}

pub fn (mut b StringBuilder) stmt(stmt ast.Stmt) {
	match stmt {
		ast.FnDecl { b.fn_decl(stmt) }
		ast.Module { b.writeln(stmt) }
		ast.ExprStmt { b.expr_stmt(stmt) }
		else { b.writeln(stmt) }
	}
}

pub fn (mut b StringBuilder) fn_decl(v ast.FnDecl) {
	b.begin_struct('FnDecl')

	b.write_field('name', v.name)
	b.write_field('mod', v.mod)
	b.write_label('params')
	b.params(...v.params)
	b.write_field('is_pub', v.is_pub)
	b.write_field('is_method', v.is_method)
	b.write_field('is_anon', v.is_anon)
	b.write_field('is_builtin', v.is_builtin)
	b.write_field('is_generic', v.is_generic)
	b.write_field('is_deprecated', v.is_deprecated)
	b.write_field('is_manualfree', v.is_manualfree)
	b.write_field('is_direct_arr', v.is_direct_arr)
	b.write_field('is_variadic', v.is_variadic)
	b.write_field('no_body', v.no_body)
	b.write_label('receiver')
	b.node(v.receiver)
	b.write_field('no_body', v.no_body)
	b.write_field('pos', v.pos)
	b.write_field('body_pos', v.body_pos)
	b.write_label('stmts')
	b.stmts(...v.stmts)
	b.write_label('return_type')
	b.typ(v.return_type)
	b.write_label('comments')
	b.exprs(...v.comments)
	b.write_label('next_comments')
	b.exprs(...v.next_comments)

	b.end_struct()
}

pub fn (mut b StringBuilder) expr_stmt(stmt ast.ExprStmt) {
	b.begin_struct('ExprStmt')

	b.write_label('expr')
	b.expr(stmt.expr)
	b.write_field('pos', stmt.pos)
	b.write_label('comments')
	b.exprs(...stmt.comments)
	b.write_field('is_expr', stmt.is_expr)

	b.end_struct()
}