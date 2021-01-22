module ast

import v.table

pub fn (mut b StringBuilder) typ(v table.Type) {
	b.writeln('${b.table.type_to_str(v)} -> table.Type($v)')
}

pub fn (mut b StringBuilder) params(params ...table.Param) {
	n := params.len
	b.begin_array(n)
	for p in params {
		b.param(p)
		b.array_comma(n)
	}
	b.end_array(n)

}
pub fn (mut b StringBuilder) param(v table.Param) {
	b.begin_struct('Param')

	b.write_field('name', v.name)
	b.write_field('is_mut', v.is_mut)
	b.write_field('is_hidden', v.is_hidden)
	b.write_field('pos', v.pos)
	b.write_label('typ')
	b.typ(v.typ)
	b.write_field('type_pos', v.type_pos)

	b.end_struct()
}