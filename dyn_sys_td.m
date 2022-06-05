function dz = dyn_sys_td(t,z,A,B)
%
dz=A*z+B*ext_harm_load(t);
%
end

