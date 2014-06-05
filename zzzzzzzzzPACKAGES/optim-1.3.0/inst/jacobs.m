## Copyright (C) 2011 Fotios Kasolis <fotios.kasolis@gmail.com>
## Copyright (C) 2013 Olaf Till <i7tiol@t-online.de>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {Df =} jacobs (@var{x}, @var{f})
## @deftypefnx {Function File} {Df =} jacobs (@var{x}, @var{f}, @var{hook})
## Calculate the jacobian of a function using the complex step method.
##
## Let @var{f} be a user-supplied function. Given a point @var{x} at
## which we seek for the Jacobian, the function @command{jacobs} returns
## the Jacobian matrix @code{d(f(1), @dots{}, df(end))/d(x(1), @dots{},
## x(n))}. The function uses the complex step method and thus can be
## applied to real analytic functions.
##
## The optional argument @var{hook} is a structure with additional options. @var{hook}
## can have the following fields:
## @itemize @bullet
## @item
## @code{h} - can be used to define the magnitude of the complex step and defaults
## to 1e-20; steps larger than 1e-3 are not allowed.
## @item
## @code{fixed} - is a logical vector internally usable by some optimization
## functions; it indicates for which elements of @var{x} no gradient should be
## computed, but zero should be returned.
## @end itemize
##
## For example:
## 
## @example
## @group
## f = @@(x) [x(1)^2 + x(2); x(2)*exp(x(1))];
## Df = jacobs ([1, 2], f)
## @end group
## @end example
## @end deftypefn

function Df = jacobs (x, f, hook)

  if ( (nargin < 2) || (nargin > 3) )
    print_usage ();
  endif

  if (ischar (f))
    f = str2func (f, "global");
  endif

  n  = numel (x);

  default_h = 1e-20;
  max_h = 1e-3; # must be positive

  if (nargin > 2)

    if (isfield (hook, "h"))
      if (! (isscalar (hook.h)))
        error ("complex step magnitude must be a scalar");
      endif
      if (abs (hook.h) > max_h)
        warning ("complex step magnitude larger than allowed, set to %e", ...
                 max_h)
        h = max_h;
      else
        h = hook.h;
      endif
    else
      h = default_h;
    endif

    if (isfield (hook, "fixed"))
      if (numel (hook.fixed) != n)
        error ("index of fixed parameters has wrong dimensions");
      endif
      fixed = hook.fixed(:);
    else
      fixed = false (n, 1);
    endif

    if (isfield (hook, 'parallel_local'))
      parallel_local = hook.parallel_local;
    else
      parallel_local = false;
    end

  else

    h = default_h;
    fixed = false (n, 1);
    parallel_local = false;

  endif

  if (all (fixed))
    error ("all elements of 'x' are fixed");
  endif

  x = repmat (x(:), 1, n) + h * 1i * eye (n);

  idx = find (! fixed).';

  if (parallel_local)
    ## symplicistic approach, fork for each computation and leave all
    ## scheduling to kernel; otherwise arguments would have to be passed
    ## over pipes, not sure whether this would be faster

    n_childs = sum (! fixed);
    child_data = zeros (n_childs, 4); # pipe descriptor for reading,
                                # pid, line number, parameter number
    child_data(:, 3) = (1 : n_childs).';
    active_childs = true (n_childs, 1);

    unwind_protect

      ready = false;
      lerrm = lasterr ();
      lasterr ("");

      cid = 0;
      for count = idx

        cid++;
        child_data(cid, 4) = count;
        [pd1, pd2, err, msg] = pipe ();
        if (err)
          error ("could not create pipe: %s", msg);
        endif
        child_data(cid, 1) = pd1;

        if ((pid = fork ()) == 0)
          ## child
          pclose (pd1);
          unwind_protect
            tp = imag (f (x(:, count))(:) / h);
            __bw_psend__ (pd2, tp);
          unwind_protect_cleanup
            pclose (pd2);
            __internal_exit__ ();
          end_unwind_protect
          ## end child
        elseif (pid > 0)
          child_data(cid, 2) = pid;
          pclose (pd2);
        else
          error ("could not fork");
        endif

      endfor

      first = true;
      while (any (active_childs))

        [~, act] = select (child_data(active_childs, 1), [], [], -1);
        act_idx = child_data(active_childs, 3)(act);

        for id = act_idx.'

          res = __bw_prcv__ (child_data(id, 1));
          if (ismatrix (res))
            error ("child closed pipe without sending");
          endif
          res = res.psend_var;

          pclose (child_data(id, 1));
          child_data(id, 1) = 0;
          waitpid (child_data(id, 2));
          child_data(id, 2) = 0;
          active_childs(id) = false;

          if (first)
            dim = numel (res);
            Df = zeros (dim, n);
            first = false;
          endif

          Df(:, child_data(id, 4)) = res;

        endfor

      endwhile

      ready = true; # try/catch would not handle ctrl-c

    unwind_protect_cleanup

      if (! ready)                     
        for (id = 1 : n_childs)
          if (child_data(id, 1))
            pclose (child_data(id, 1));
            if (child_data(id, 2))
              system (sprintf ("kill -9 %i", child_data(id, 2)));
              waitpid (child_data(id, 2));
            endif
          endif
        endfor

        nerrm = lasterr ();
        error ("no success, last error message: %s", nerrm);

      endif

      lasterr (lerrm);

    end_unwind_protect

  else # not parallel

    ## after first evaluation, dimensionness of 'f' is known
    t_Df = imag (f (x(:, idx(1)))(:));
    dim = numel (t_Df);

    Df = zeros (dim, n);

    Df(:, idx(1)) = t_Df;

    for count = idx(2:end)
      Df(:, count) = imag (f (x(:, count))(:));
    endfor

    Df /=  h;

  endif

endfunction

%!assert (jacobs (1, @(x) x), 1)
%!assert (jacobs (6, @(x) x^2), 12)
%!assert (jacobs ([1; 1], @(x) [x(1)^2; x(1)*x(2)]), [2, 0; 1, 1])
%!assert (jacobs ([1; 2], @(x) [x(1)^2 + x(2); x(2)*exp(x(1))]), [2, 1; 2*exp(1), exp(1)])

%% Test input validation
%!error jacobs ()
%!error jacobs (1)
%!error jacobs (1, 2, 3, 4)
%!error jacobs (@sin, 1, [1, 1])
%!error jacobs (@sin, 1, ones(2, 2))

%!demo
%! # Relative error against several h-values
%! k = 3:20; h = 10 .^ (-k); x = 0.3*pi;
%! err = zeros (1, numel (k));
%! for count = 1 : numel (k)
%!   err(count) = abs (jacobs (x, @sin,	struct ("h", h(count))) - cos (x)) / abs (cos (x)) + eps;
%! endfor
%! loglog (h, err); grid minor;
%! xlabel ("h"); ylabel ("|Df(x) - cos(x)| / |cos(x)|")
%! title ("f(x)=sin(x), f'(x)=cos(x) at x = 0.3pi")
