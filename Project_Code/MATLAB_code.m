
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

serialPort = 'COM3';
baudRate = 9600;
s = serial(serialPort, 'BaudRate', baudRate);

try
    fopen(s);
    disp('Serial port opened successfully.');
    time = datetime('now') - seconds(30); 
    temperatureC = 0;
    temperatureF = 0; 
    windowSize = 5; 
    celsiusBuffer = NaN(windowSize, 1);
    fahrenheitBuffer = NaN(windowSize, 1);
    bufferIndex = 1;
    figure;
    hC = plot(time, temperatureC, 'r');
    hold on;
    hF = plot(time, temperatureF, 'b');
    xlabel('Time');
    ylabel('Temperature');
    title('Live Temperature Data');
    legend('Celsius', 'Fahrenheit');
    grid on;
    txtBox = annotation('textbox', [0.75, 0.75,0.1,0.1], 'String', '', 'EdgeColor', 'black');

    while true
        if s.BytesAvailable > 0
            data = fscanf(s, '%f');
            celsiusBuffer(bufferIndex) = data/10.24;
            fahrenheitBuffer(bufferIndex) = (celsiusBuffer(bufferIndex)*(9/5))+32;
            avgCelsius = mean(celsiusBuffer(~isnan(celsiusBuffer)));
            avgFahrenheit = mean(fahrenheitBuffer(~isnan(fahrenheitBuffer)));
            time = [time datetime('now')];
            temperatureC = [temperatureC avgCelsius];
            temperatureF = [temperatureF avgFahrenheit];
            set(hC, 'XData', time, 'YData', temperatureC);
            set(hF, 'XData', time, 'YData', temperatureF);
            drawnow;
            currentCelsius = celsiusBuffer(bufferIndex);
            currentFahrenheit = fahrenheitBuffer(bufferIndex);
            txtBox.String = sprintf('Current Celsius: %.2f\nCurrent Fahrenheit: %.2f\nAverage Celsius: %.2f\nAverage Fahrenheit: %.2f', ...
                                    currentCelsius, currentFahrenheit, avgCelsius, avgFahrenheit);

            bufferIndex = mod(bufferIndex, windowSize) + 1;
        end
    end
catch ME
    disp(['An error occurred: ', ME.message]);
    fclose(s);
    delete(s);
    clear s;
end
