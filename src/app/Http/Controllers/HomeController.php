<?php

namespace App\Http\Controllers;

/**
 * Class HomeController
 *
 * @package App\Http\Controllers
 */
class HomeController extends Controller
{
    /**
     * @return array
     */
    public function show(): array
    {
        return [
            'active' => true,
            'version' => '1.0'
        ];
    }
}
