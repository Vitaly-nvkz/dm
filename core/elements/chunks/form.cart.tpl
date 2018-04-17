    <section class="py-4">
        <div class="container" id="msCart">
            <h1>Корзина покупок</h1>
            {if count($products) == 0}
            <div style="margin:7rem 0 10rem;text-align:center;font-size:2rem">Корзина пуста.</div>
        </div>
    </section>
            {else}
            <table class="table table-striped table-hover mt-4">
                <tbody>
                {foreach $products as $product}
                {set $noShadow = ! (
                    ($product.parent in [$_modx->config.'resources.steel_doors', $_modx->config.'resources.room_doors'])
                    && $product.thumb
                )}
                <tr id="{$product.key}" class="cart-item">
                    <td>
                        <div class="card-product card-product--small px-3{if $product.'type_of_goods.value' == 'Фурнитура'} furniture{/if}">
                                <div class="d-inline-block align-top mr-4 {if $product.'type_of_goods.value' == 'Фурнитура'}w-rem-12{else}w-rem-20{/if}">
                                    <div class="overlay-door mb-3{if !$product.thumb} no-photo{/if}">
                                        <div class="mask mask-door"{if $noShadow} style="background:none;"{/if}>
                                            <a href="{$product.id | url}">
                                            {if $product.thumb?}
                                                <img src="{$product.thumb}" alt="{$product.pagetitle | escape}" title="{$product.pagetitle | escape}"/>
                                            {else}
                                                <img style="width:150px;" src="{$_modx->config.assets_url}images/no-photo.png" alt="{$product.pagetitle | escape}" title="{$product.pagetitle | escape}"/>
                                            {/if}
                                            </a>
                                        </div>
                                    </div>
                                    <div class="card-block">
                                        <a href="{$product.id | url}" class="card-title">{$product.pagetitle}</a>
                                        {if $_modx->config.'resources.room_doors' == $product.parent}
                                        <div class="mt-2">
                                            Размер: {$product.'width.value'}х{$product.'height.value'}
                                        </div>
                                        <div class="card-description">
                                            Покрытие: {$product.'cover.value'}<br>
                                            Цвет: {$product.'mscolor.value'}
                                        </div>
                                        {/if}
                                    </div>
                                </div>
                                <div class="d-inline-block">
                                    <div class="d-inline-block align-top mr-4">
                                        <div>Количество</div>
                                        <form method="post" class="ms2_form" role="form">
                                            <input type="hidden" name="key" value="{$product.key}"/>
                                            <input type="number" class="form-control form-control-sm form-control--border w-rem-4 mb-3 mr-2 d-inline-block" value="{$product.count}" min="0" step="{if $product.menutitle == 'Короб' || $product.menutitle == 'Наличник'}0.2{else}1{/if}" name="count" placeholder="">
                                            <button type="submit" name="ms2_action" value="cart/change" style="display:none;"></button>
                                            <div class="card-price d-inline-block">
                                                x&nbsp;<span class="price ms2_product_price">{$product.price}</span>&nbsp;<span class="icon-rub"></span>
                                            </div>
                                            {$_modx->RunSnippet('!msAddLinked.info', [
                                                'key' => $product.key,
                                                'option' => $product.options.msal,
                                            ])}
                                        </form>
                                    </div>
                                </div>
                                <div class="d-inline-block align-top ml-4 float-right">
                                    <div class="lead">Итого</div>
                                    <div class="d-inline-block h3">
                                        <span class="price ms2_total_row_cost">{$product.cost}</span>&nbsp;<span class="icon-rub"></span>
                                    </div>
                                </div>
                                <div class="d-inline-block float-right">
                                    <form method="post" class="ms2_form" role="form">
                                        <input type="hidden" name="key" value="{$product.key}">
                                        <button type="submit" name="ms2_action" value="cart/remove" class="btn btn-sm btn-outline-secondary mt-3"><span class="icon-close"></span>Удалить</button>
                                    </form>
                                </div>
                        </div>
                    </td>
                </tr>
                {/foreach}
                </tbody>
                <tfoot>
                <tr>
                    <th class="card-title lead">
                        <div id="cartClean">
                            <form class="ms2_form">
                                <button type="submit" name="ms2_action" value="cart/clean" class="btn btn-secondary">Очистить корзину</button>
                            </form>
                        </div>
                        <div class="text-right">
                            <strong>Итого</strong>
                            <div class="card-price d-inline-block ml-3 ">
                                <div class="h2"><span class="price ms2_total_cost">{$total.cost}</span><span class="icon-rub"></span> </div>
                            </div>
                        </div>
                    </th>
                </tr>
                </tfoot>
            </table>
        </div>
    </section>
{/if}
