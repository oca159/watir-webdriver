module Watir
  class TableCell < HTMLElement
    # @private
    attr_writer :locator_class

    def locator_class
      @locator_class || super
    end

    def colspan
      value = attribute_value :colspan
      value ? Integer(value) : 1
    end
  end # TableCell

  module Container
    def cell(*args)
      cell = TableCell.new(self, extract_selector(args).merge(:tag_name => /^(th|td)$/))
      cell.locator_class = ChildCellLocator

      cell
    end

    def cells(*args)
      cells = TableCellCollection.new(self, extract_selector(args).merge(:tag_name => /^(th|td)$/))
      cells.locator_class = ChildCellLocator

      cells
    end
  end # Container

  class TableCellCollection < ElementCollection
    attr_writer :locator_class

    def locator_class
      @locator_class || super
    end

    def elements
      # we do this craziness since the xpath used will find direct child rows
      # before any rows inside thead/tbody/tfoot...
      elements = super

      if locator_class == ChildCellLocator
        elements = elements.sort_by { |row| row.attribute(:cellIndex).to_i }
      end

      elements
    end

  end # TableCellCollection
end # Watir
