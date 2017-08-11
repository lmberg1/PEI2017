function times = cutTimes(header)
%given a SAC header, returns times for start time, P wave arrival, S wave
%arrival, and end time
times(1) = header.b;
times(2) = round(header.a, 2);
times(3) = round(header.t0, 2);
times(4) = header.e;