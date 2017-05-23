function result = clamp(value, low, high)
    if value < low
        result = low;
    elseif value > high
        result = high;
    else
        result = value;
    end
    return;
end