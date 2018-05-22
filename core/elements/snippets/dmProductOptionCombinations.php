<?php

/**
 * This snippet is a fast and temporary solution
 * IMPORTANT: this snippet should be an implementation of dmProductOptions in order of avoiding duplicate code
 */

// Retrive options
$conditions = $modx->getOption('conditions', $scriptProperties);
$currentOptionValues = $modx->getOption('currentOptionValues', $scriptProperties);
$optionKeys = $modx->getOption('optionKeys', $scriptProperties);
$optionLabel = $modx->getOption('optionLabel', $scriptProperties);
$showSingleOption = $modx->getOption('showSingleOption', $scriptProperties);
$tpl = $modx->getOption('tpl', $scriptProperties);
$tplWrapper = $modx->getOption('tplWrapper', $scriptProperties);

// Use pdoTools if it's possible
if (class_exists('pdoTools')) {
    $pdoTools = $modx->getService('pdoTools');
    // Using $pdoTools->getChunk($tpl, $placeholders)
} else {
    // Using $modx->getChunk($tpl, $placeholders)
}

// Set empty conditions if not an array is passed
if (!is_array($conditions)) {
    $conditions = [];
}

// Remove condtions with empty value
foreach ($conditions as $key => $value) {
    if (empty($value)) {
        unset($conditions[$key]);
    }
}

// Cast current option values to array
$currentOptionValues = json_decode($currentOptionValues, true);

// Build subquery for product ids with specified option conditions
$productIDsSubquery = $modx->newQuery('msProductOption');
$whereCondition = [];
foreach ($conditions as $key => $value) {
    $productIDsSubquery->leftJoin('msProductOption', $key, "msProductOption.product_id = $key.product_id");
    $whereCondition["$key.value"] = $value;
}
$productIDsSubquery->where($whereCondition)
                   ->groupby('msProductOption.product_id');
$productIDsSubquery->select('msProductOption.product_id');
$productIDsSubquery->prepare();
// echo $productIDsSubquery->toSQL();

// Get unique options with specified option keys and product ids having specified option key and value (retrieved by subquery above)
$criteria = $modx->newQuery('msProductOption');

$optionKeys = explode('|', $optionKeys);
$selectionFields = [
    'msProductOption.product_id',
];

// Join tables with specified keys
foreach ($optionKeys as $optionKey) {
    $criteria->leftJoin('msProductOption', $optionKey, "$optionKey.product_id = msProductOption.product_id AND $optionKey.`key` = '$optionKey'");
    $selectionFields[] = "$optionKey.value AS $optionKey";
}
$criteria->where([
             'msProductOption.product_id IN (' . $productIDsSubquery->toSQL() . ')',
           ]);
// Group by specified key values
$criteria->groupby(implode(',', $optionKeys));

$criteria->select($selectionFields);
// $criteria->prepare();
// echo $criteria->toSQL();

// Retrive the collection
$productOptionCollection = $modx->getCollection('msProductOption', $criteria);

// Nothing to output
if (! $showSingleOption && sizeof($productOptionCollection) <= 1) {
    return;
}

// Prepare the items
$items = '';
foreach ($productOptionCollection as $id => $productOption) {
    $optionValues = [];
    foreach ($optionKeys as $optionKey) {
        $optionValues[$optionKey]  = $productOption->get($optionKey);
    }
    $productId = $productOption->get('product_id');
    // Find product in the cart
    $productCartKey = '';
    foreach ($_SESSION['minishop2']['cart'] as $cartKey => $cartItem) {
        if ($productId == $cartItem['id']) {
            $productCartKey = $cartKey;
            break;
        }
    }
    $placeholders = [
        'id' => $id + 1,
        'optionKeys' => $optionKeys,
        'productId' => $productId,
        'optionValues' => $optionValues,
        'optionImage' => $productOption->get('pattern'),
        'currentOptionValues' => $currentOptionValues, // For recognize active items
        'productCartKey' => $productCartKey,
        'productCartCount' => $productCartKey ? $_SESSION['minishop2']['cart'][$productCartKey]['count'] : 0,
    ];
    $items .= !empty($pdoTools)
        ? $pdoTools->getChunk($tpl, $placeholders)
        : $modx->getChunk($tpl, $placeholders);
}

// Wrap the items
$placeholders = [
    'items' => $items,
    'optionLabel' => $optionLabel,
];
$output = !empty($pdoTools)
    ? $pdoTools->getChunk($tplWrapper, $placeholders)
    : $modx->getChunk($tplWrapper, $placeholders);
return $output;
