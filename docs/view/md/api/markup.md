# Fluent Ui Markup Syntax

Fluent Ui documents should be created using the markup system. To do so, just follow the basic markup syntax. Below is a basic example of creating a
parent element, and a child element.

```lua
Fluent.file.create({Name = "Index", Contents = {
    {'<parent1? type="Frame" parent="&;" name="parent1">', {
        {'<child1? type="Frame" parent="^" name="child1">'}
    }}
}})
```

Elements support basic attributes that help you change the order of elements in your document, and the basic properties of them in the roblox explorer.

### Markup Attributes
- parent
    - Controls the order that the element is rendered in by changing what instance it is parented to.
    - The `&;` value will parent the element to the container, ignoring the order it is in inside of the document layout.
    - The `^` value will parent the element to the previously rendered instance, this is the default parent value for children elements.
- name
    - Controls the name of the element, defaults to the tag type.
- type
    - Controls the type of the rendered instance in the Roblox game, defaults to Frame.
- tag
    - Controls the `fluent:style-tag` of the element for styling.
    - Can't be set using the normal syntax of `attribute="value"`, and will only be set by using the text that comes before `?`
        - example: `<FluentButton? attribute="value">`, where `FluentButton` would be the tag