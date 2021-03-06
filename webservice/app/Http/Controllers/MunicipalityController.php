<?php

/*
 * This file is part of SmartGas, an iOS app to find the best gas station nearby.
 *
 * (c) Fábio Santos <ffsantos92@gmail.com>
 * (c) Mateus Silva <mateusgsilva_@hotmail.com>
 * (c) Fábio Marques <fabio1956.epo@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App\Http\Controllers;

class MunicipalityController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $municipalities = app('db')->table('municipalities')
            ->get(['id', 'value', 'district_id', 'updated_at']);

        return response()->json(['municipalities' => $municipalities], 200, [], JSON_NUMERIC_CHECK);
    }

    /**
     * Display the specified resource.
     *
     * @param int $id
     *
     * @return Response
     */
    public function show($id)
    {
        $municipality = app('db')->table('municipalities')->where('id', $id)
            ->first(['id', 'value', 'district_id', 'updated_at']);

        return response()->json(['municipality' => $municipality], 200, [], JSON_NUMERIC_CHECK);
    }
}
