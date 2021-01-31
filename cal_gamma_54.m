function [output] = cal_gamma_54(f)
  output = (7.2*r_t^2.8/(f^2+0.34*r_p^2*r_t^1.6)+0.62*kesai3/((54-f)^(1.16*kesai1)+0.83*kesai2))*f^2*r_p^2*10^-3;
  