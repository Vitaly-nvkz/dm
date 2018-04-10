{if $menutitle == 'Короб'}
    {set $tooltipText = '<strong>Короб</strong>&nbsp;&mdash;&nbsp;рамочная П-образная конструкция, на которую навешивается дверное полотно. Это неподвижная часть дверного блока, которая прочно закрепляется в стенках дверного проема.'}
    {set $step = 0.2}
    {set $unit = 'к.'}
{elseif $menutitle == 'Наличник'}
    {set $tooltipText = '<strong>Наличники</strong>&nbsp;&mdash;&nbsp;накладные планки, закрывающие стыки и щели между дверной коробкой и стеной. Служат декоративным элементом обрамления двери, бывают плоские, скруглённые, фигурные, телескопические и на шпонке.'}
    {set $step = 0.2}
    {set $unit = 'к.'}
{elseif $menutitle == 'Добор'}
    {set $tooltipText = '<strong>Дверной добор</strong>&nbsp;&mdash;&nbsp;планка, применяющаяся для продолжения дверной коробки, ширина которой меньше размера толщины стен. Это декораторский прием, выигрышно улучшающий комплексную отделку дверного проема, и сохраняющий целостность композиции двери.'}
    {set $step = 1}
    {set $unit = 'шт.'}
{elseif $menutitle == 'Притворная планка'}
    {set $tooltipText = '<strong>Притворная планка</strong>&nbsp;&mdash;&nbsp;это тонкая рейка, расположенная на краю дверного полотна и при закрывании плотно прилегающая к дверной коробке. Без такой планки при закрытых дверях остается зазор, через который в помещение проникают посторонние звуки и сквозняк.'}
    {set $step = 1}
    {set $unit = 'шт.'}
{else}
    {set $tooltipText = 'Нет данных'}
    {set $step = 0}
    {set $unit = 'шт.'}
{/if}
<tr>
    <td>
        <div class="lead">
            [[+productName]]
            <span class="question-mark-icon" data-toggle="tooltip" data-html="true" data-placement="right" title="<div style='padding:.75rem;text-align:left;text-indent:1rem;'>{$tooltipText}<div>"></span>
        </div>
    </td>
    <td>
        <form class="ms2_form" data-link-name="[[+linkName]]" data-id="[[+id]]" method="post">
            <div class="input-group">
                <input name="count" type="number" min="0" step="{$step}" class="form-control form-control-sm form-control--border w-rem-4" value="[[+count]]" placeholder="">
                <span class="input-group-addon form-control-sm form-control--border">{$unit}</span>
            </div>
            <input type="hidden" name="id" value="[[+id]]">
            [[+cartKey:notempty=`<input type="hidden" name="key" value="[[+cartKey]]" />`]]
            <input name="options" value="[]" type="hidden">
            <button type="submit" name="ms2_action" value="[[+count:is=`0`:then=`cart/add`:else=`cart/change`]]"></button>
        </form>
        </td>
    <td>
        <div class="card-price">
            x&nbsp;<span class="price ms2_product_price">[[+price]]</span>&nbsp;<span class="icon-rub"></span>
        </div>
    </td>
    <td>
        <div class="card-price">
            =&nbsp;<span class="price ms2_total_row_cost">[[+sum]]</span>&nbsp;<span class="icon-rub"></span>
        </div>
    </td>
</tr>
