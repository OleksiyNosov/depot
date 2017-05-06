require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  def new_poduct_from_price(price)
    Product.new(title:        "My Book Title",
                description:  "Good book",
                image_url:    "book.jpg",
                price:        price)
  end
  test "product price must not be neagative" do
    product = new_poduct_from_price(-1)

    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
  end

  test "product price must not be zero" do
    product = new_poduct_from_price(0)

    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
  end

  test "product price must be positive for minimal price" do
    product = new_poduct_from_price(0.01)

    assert product.valid?
  end

  test "product price must be positive" do
    product = new_poduct_from_price(1)

    assert product.valid?
  end

  def new_poduct_from_url(image_url)
    Product.new(title:        "My Book Title",
                description:  "Good book",
                image_url:    image_url,
                price:        1)
  end
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/freg.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |url|
      assert new_poduct_from_url(url).valid?, "#{url} shouldn't be invalid"
    end

    bad.each do |url|
      assert new_poduct_from_url(url).invalid?, "#{url} shouldn't be valid"
    end
  end

  test "product is not valid withour a unique title - i18n" do
    product = Product.new(title:        products(:ruby_book).title,
                          description:  "Good book",
                          image_url:    "book.png",
                          price:        1)
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end
end
