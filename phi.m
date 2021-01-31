function [output] = phi(r_p, r_t, a, b, c, d)
output = r_p^a*r_t^b*exp((c*(1-r_p)+d*(1-r_t)));