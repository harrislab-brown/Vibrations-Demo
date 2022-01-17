## Copyright (C) 2022 Harris Lab Brown University 
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

##
## @seealso{}
## @end deftypefn


function octave_vibrations_lab_audio_out_v2 (audiodevinfoID,runtime,f1,f2,A1,A2)
  
  #audiodevinfoID is the device number information.
  #runtime is the time in seconds the code runs for.
  #f1 is the shaker frequency
  #f2 is the frequency of the lights

  Fs =40000; #Sampling frequency
  T=1/Fs; #Time period

  t=0:T:runtime; #Loop over time steps
  
  omega1= 2*pi*f1; 
  
  omega2= 2*pi*f2; 


  x=A1*sin(omega1*t); #create sine wave signal for the shaker

  y=A2.*((square(omega2*t,20)+1)./2); #create square wave signal for lights

  Out = [x; y]; #output to create audiofile
  app.player = audioplayer(Out, Fs, 16, audiodevinfoID); # generate audiofile
  play(app.player) #play audiofile
  pause(runtime); 

endfunction
