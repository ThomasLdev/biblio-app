<?php

/**
 * @author tlefebvre@norsys.fr
 */

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HomeController extends AbstractController
{
    #[Route('/', name: 'homepage')]
    public function index(): Response
    {
        return $this->render('biblio/index.html.twig', [
            'controller_name' => 'ConferenceController',
        ]);
    }
}