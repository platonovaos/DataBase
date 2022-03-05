create or replace procedure show_functions() as
$$
declare 
	cur cursor
	for select proname, proargtypes
	from (
		select proname, pronargs, prorettype, proargtypes
		from pg_proc
		where pronargs > 0
	) AS tmp;
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice '{func_name : %} {args : %}', row.proname, row.proargtypes;
	end loop;
	close cur;
end
$$ language plpgsql;

call show_functions();
