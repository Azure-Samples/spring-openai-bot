package com.microsoft.samples.springopenai.data;

import java.util.List;

public class EventData {

    List<EventChoice> choices;

    public List<EventChoice> getChoices() {
        return choices;
    }

    public void setChoices(List<EventChoice> choices) {
        this.choices = choices;
    }
}
