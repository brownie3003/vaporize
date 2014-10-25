module SubscriptionsHelper

    # ref: http://www.redguava.com.au/2011/03/rails-3-select-list-items-with-custom-attributes/
    def options_from_collection_for_select_with_attributes(collection, value_method, text_method, data = {}, selected = nil)
        options = collection.map do |element|
            [element.send(text_method), element.send(value_method), data.map do |k, v|
                {"data-#{k}" => element.send(v)}
            end
            ].flatten
        end

        selected, disabled = extract_selected_and_disabled(selected)
        select_deselect = {}
        select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
        select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

        options_for_select(options, select_deselect)
    end
end
